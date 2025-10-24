# Fluent-Bit Suricata Enrichment

This project provides an example of a [Fluent Bit](https://fluentbit.io) Lua filter for processing [Suricata IDS/IPS](https://suricata.io) ```eve.json``` logs. It bridges the gap between Suricata's verbose output format and modern observability platforms by normalizing and enriching security events.

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)

## Features

The example Lua script will:

- **Normalize severity alerts**: Converts Suricata's numeric severity (1/2/3) to descriptive levels (critical/high/medium/low/) for humans to read
- **Category Mapping**: Gives an example way to change verbose Suricata categories to short names
- **Critical Alert Flagging**: Adds `alert.is_critical` boolean for priority-based alerting based on Suricata's numeric severity (1/2/3)
- **ECS Compatibility**: Adds `event.category` and `event.severity` fields compatible with Elastic Common Schema (also works with OpenSearch)

## Quick Start

To start the example run:

```zsh
docker compose up -d 
```

When you're finished:

```zsh
docker compose down
```

**Before:**

```json
{"timestamp":"2024-10-23T14:34:20.789012+0000","flow_id":123456791,"event_type":"alert","src_ip":"172.16.5.10","src_port":22,"dest_ip":"203.0.113.99","dest_port":55123,"proto":"TCP","alert":{"action":"allowed","gid":1,"signature_id":2024003,"signature":"ET SCAN Potential SSH Scan","category":"Network Scan","severity":3}}
```

**After:**

```json
{
  "event_type": "alert",
  "alert": {
    "signature": "ET SCAN Potential SSH Scan",
    "category": "Network Scan",
    "severity": 3,
    "is_critical": false,
    "readable_category": "malware"
  },
  "event": {
    "severity": "medium",
    "category": "reconnaissance"
  }
}
```

Sample Suricata events are provided in `examples/eve.json`

## Assumptions

The configuration file ```fluent-bit.conf``` assumes that you are keeping the ```eve.json``` log file in the default location: ```/var/log/suricata/eve.json```.

Under the ```[INPUT]``` section in ```fluent-bit.conf```:
```zsh
[INPUT]
    Name              tail
    Tag               suricata
    Path              /var/log/suricata/eve.json
    Parser            json
    Mem_Buf_Limit     50MB
    Skip_Long_Lines   On
    Skip_Empty_Lines  On
    Refresh_Interval  5
    Read_from_Head    true
```

There is a ```Read_from_Head    true``` line. In a production environment you will need to change this from ```true``` to ```false```!

## Official Documentation

- [Suricata EVE JSON Format](https://docs.suricata.io/en/latest/output/eve/eve-json-format.html)
- [Fluent Bit Lua Filter](https://docs.fluentbit.io/manual/data-pipeline/filters/lua)
- [Fluent Bit Tail Input](https://docs.fluentbit.io/manual/data-pipeline/inputs/tail)

## License

Apache License 2.0: See [LICENSE](LICENSE) for details.
