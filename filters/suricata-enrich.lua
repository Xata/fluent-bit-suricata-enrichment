function enrich_suricata(tag, timestamp, record)
    -- Only enrich alert events
    -- This will not enrich DNS, HTTP, TLS, type logs that are also found in eve.json
    if record["event_type"] == "alert" and record["alert"] ~= nil then
        local alert = record["alert"]
        
        -- Normalize Suricata severity levels: 1=high, 2=medium, 3=low
        local priority = alert["severity"] or 3
        local severity_name = "info"
        local is_critical = false
        
        if priority == 1 then
            severity_name = "critical"
            is_critical = true
        elseif priority == 2 then
            severity_name = "high"
        elseif priority == 3 then
            severity_name = "medium"
        else
            severity_name = "low"
        end
        
        -- Add normalized fields
        record["event"] = record["event"] or {}
        record["event"]["severity"] = severity_name
        alert["is_critical"] = is_critical
        
        -- Map example alert categories to standardized names
        local classtype = alert["category"] or "unknown"
        local category_map = {
            ["A Network Trojan was detected"] = "malware",
            ["Web Application Attack"] = "web_attack",
            ["Attempted Administrator Privilege Gain"] = "privilege_escalation",
            ["Denial of Service"] = "dos",
            ["Network Scan"] = "reconnaissance",
            ["Malware Command and Control Activity Detected"] = "command_and_control"
        }
        
        alert["readable_category"] = category_map[classtype] or "other"
        record["event"]["category"] = alert["readable_category"]
    end
    
    return 2, timestamp, record
end
