package com.traffic.dao;

import com.traffic.model.TrafficRule;
import java.util.List;

public interface TrafficRuleDAO {
	List<TrafficRule> getAllTrafficRules();

	TrafficRule getTrafficRuleById(int ruleId);
}
