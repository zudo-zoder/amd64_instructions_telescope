# ChatGPT ahh 

import requests
from bs4 import BeautifulSoup
import json

# Base URL
base_url = "https://www.felixcloutier.com"
url = f"{base_url}/x86/"

# Fetch page
response = requests.get(url)
response.raise_for_status()
soup = BeautifulSoup(response.text, "html.parser")

# Find the first table containing instructions
table = soup.find("table")
instructions = []

if table:
    for row in table.find_all("tr"):
        cols = row.find_all("td")
        if len(cols) >= 2:
            a_tag = cols[0].find("a")
            if a_tag:
                mnemonic = a_tag.get_text(strip=True)
                link = base_url + a_tag["href"]
                description = cols[1].get_text(strip=True)
                instructions.append({
                    "mnemonic": mnemonic,
                    "link": link,
                    "description": description
                })

# Save to JSON
output_file = "amd64_instructions.json"
with open(output_file, "w", encoding="utf-8") as f:
    json.dump(instructions, f, indent=2, ensure_ascii=False)

print(f"Saved {len(instructions)} instructions to {output_file}")
