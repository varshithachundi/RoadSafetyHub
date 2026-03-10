package com.traffic.service;

import com.traffic.model.TrafficRule;
import java.util.List;

public interface TrafficRuleService {
    List<TrafficRule> getAllTrafficRules();
    TrafficRule getTrafficRuleById(int ruleId);
}
