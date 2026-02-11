#!/usr/bin/env python3
"""
Interview exercise: scrape a Rentable property page.

Tasks (in order):
1) Fix unit availability extraction (currently uses a slightly wrong JSON path).
2) Extract photo URLs (there is a stub for it).

How to run:
uv run scrape_test.py https://www.rentable.co/san-diego-ca/mara-pacific-beach

"""

from __future__ import annotations

import json
import logging
import sys
import time
from dataclasses import dataclass, asdict
from typing import Any, Dict, List, Optional, Tuple
from urllib.parse import urljoin

import requests
from bs4 import BeautifulSoup


LOG = logging.getLogger("scrape_property")


@dataclass
class PropertyResult:
    url: str
    property_name: Optional[str]
    address: Optional[str]
    city: Optional[str]
    state: Optional[str]
    zip_code: Optional[str]
    units: List[Dict[str, Any]]  # keep flexible for now


def configure_logging(level: str = "INFO") -> None:
    logging.basicConfig(
        level=getattr(logging, level.upper(), logging.INFO),
        format="%(asctime)s %(levelname)s %(name)s %(message)s",
    )


def fetch_html(url: str, timeout_s: int = 20) -> str:
    headers = {
        # A realistic UA helps reduce basic bot-blocking.
        "User-Agent": (
            "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) "
            "AppleWebKit/537.36 (KHTML, like Gecko) "
            "Chrome/121.0.0.0 Safari/537.36"
        ),
        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
        "Accept-Language": "en-US,en;q=0.9",
    }

    start = time.time()
    resp = requests.get(url, headers=headers, timeout=timeout_s)
    elapsed = time.time() - start

    LOG.info("fetched url=%s status=%s elapsed_s=%.3f bytes=%s",
             url, resp.status_code, elapsed, len(resp.content))

    # If this hits 403 in some environments, that itself is a good debugging discussion.
    resp.raise_for_status()
    return resp.text


def safe_get(d: Any, path: List[Any]) -> Any:
    cur = d
    for key in path:
        if isinstance(cur, dict) and key in cur:
            cur = cur[key]
        elif isinstance(cur, list) and isinstance(key, int) and 0 <= key < len(cur):
            cur = cur[key]
        else:
            return None
    return cur


def parse_json_ld(soup: BeautifulSoup) -> Dict[str, Any]:
    """
    Extract basics from JSON-LD if present (often contains name and postalAddress).
    Returns a partial dict; missing fields are OK.
    """
    out: Dict[str, Any] = {}
    scripts = soup.find_all("script", attrs={"type": "application/ld+json"})
    # LOG.info("found %d json-ld scripts", len(scripts))
    for s in scripts:
        try:
            # LOG.info("parsing json-ld script content: %s", s.get_text())
            data = json.loads(s.get_text(strip=True) or "{}")
        except json.JSONDecodeError:
            continue

        # JSON-LD can be a dict or list
        candidates = data if isinstance(data, list) else [data]
        LOG.info("found %d json-ld candidates", len(candidates))
        for item in candidates:
            LOG.debug("processing json-ld item: type=%s keys=%s", type(item).__name__, list(item.keys()) if isinstance(item, dict) else "N/A")
            if not isinstance(item, dict):
                continue

            # "name" is commonly present on a listing.
            if not out.get("property_name") and isinstance(item.get("name"), str):
                out["property_name"] = item["name"]

            LOG.debug("json-ld item keys: %s", list(item.keys()))

            # postalAddress
            addr = item.get("address")
            if isinstance(addr, dict):
                out.setdefault("address", addr.get("streetAddress"))
                out.setdefault("city", addr.get("addressLocality"))
                out.setdefault("state", addr.get("addressRegion"))
                out.setdefault("zip_code", addr.get("postalCode"))

    return out


def parse_next_data(soup: BeautifulSoup) -> Optional[Dict[str, Any]]:
    script = soup.find("script", attrs={"id": "__NEXT_DATA__"})
    if not script:
        LOG.warning("no __NEXT_DATA__ script found")
        return None
    try:
        return json.loads(script.get_text(strip=True) or "{}")
    except json.JSONDecodeError:
        LOG.exception("failed to parse __NEXT_DATA__ json")
        return None


def extract_units_from_next_data(next_data: Dict[str, Any]) -> List[Dict[str, Any]]:
    units = safe_get(next_data, ["props", "pageProps", "listing", "units"])

    if units is None:
        # Provide helpful breadcrumbs for debugging
        top_keys = list(next_data.keys())
        pageprops_keys = list((safe_get(next_data, ["props", "pageProps"]) or {}).keys())
        LOG.warning(
            "units not found at expected path. top_keys=%s pageProps_keys=%s",
            top_keys, pageprops_keys
        )
        return []

    if not isinstance(units, list):
        LOG.warning("units found but not a list; type=%s", type(units).__name__)
        return []

    return units


def scrape_property(url: str) -> PropertyResult:
    html = fetch_html(url)
    soup = BeautifulSoup(html, "html.parser")

    # First try JSON-LD for the basic address/name
    ld = parse_json_ld(soup)

    LOG.info("parsed json-ld data: %s", ld)

    next_data = parse_next_data(soup) or {}

    # Units currently broken on purpose
    units = extract_units_from_next_data(next_data)

    return PropertyResult(
        url=url,
        property_name=ld.get("property_name"),
        address=ld.get("address"),
        city=ld.get("city"),
        state=ld.get("state"),
        zip_code=ld.get("zip_code"),
        units=units,
    )


def main(argv: List[str]) -> int:
    configure_logging(level="INFO")

    if len(argv) != 2:
        print(f"Usage: {argv[0]} <property_url>", file=sys.stderr)
        return 2

    url = argv[1]
    try:
        result = scrape_property(url)
        print(json.dumps(asdict(result), indent=2, sort_keys=True))
        return 0
    except requests.HTTPError as e:
        LOG.exception("http error while scraping url=%s", url)
        return 1
    except Exception:
        LOG.exception("unexpected error while scraping url=%s", url)
        return 1


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))