package com.traffic.service;

import com.traffic.dao.TrafficRuleDAO;
import com.traffic.dao.TrafficRuleDAOImpl;
import com.traffic.model.TrafficRule;
import java.util.List;

public class TrafficRuleServiceImpl implements TrafficRuleService {

    TrafficRuleDAO dao = new TrafficRuleDAOImpl();

    @Override
    public List<TrafficRule> getAllTrafficRules() {
        return dao.getAllTrafficRules();
    }

    @Override
    public TrafficRule getTrafficRuleById(int ruleId) {
        return dao.getTrafficRuleById(ruleId);
    }
}
