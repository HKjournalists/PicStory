package com.towne.framework.springmvc.controller;

import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeoutException;
import java.util.Set;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.code.ssm.Cache;
import com.google.code.ssm.api.format.SerializationType;
import com.google.code.ssm.providers.CacheException;
import com.towne.framework.common.service.IFacadeService;
import com.towne.framework.system.util.GsonUtil;
import com.towne.framework.springmvc.model.MomentV;
import com.towne.framework.springmvc.model.Moments;
import com.towne.framework.springmvc.model.PageV;
import com.towne.framework.common.model.Trader;
import com.towne.framework.hibernate.model.Moment;
import com.towne.framework.hibernate.model.Page;

/**
 * return json format data
 * @author towne
 *
 */
@Controller
@RequestMapping(value="/json",method={RequestMethod.GET})
public class ResponseJsonController {
	
	@Autowired
	IFacadeService ifacadeService;
	
	@Autowired
	private Cache cache;
	
	@RequestMapping(value="/moment/{id}",produces=MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody MomentV getContactInJSON(@PathVariable(value="id")long id) throws TimeoutException, CacheException{
		Trader trader = new Trader();
		trader.setTraderName("towne");
		trader.setTraderPassword("123");
		MomentV mv = ifacadeService.findPages(trader, id);
		System.out.println(">>>>>> "+cache.get("USER_LOGVO_127.0.0.1",SerializationType.PROVIDER));
		System.out.println(">>>>>> "+cache.get("USER_SESSION_127.0.0.1",SerializationType.PROVIDER));
		return mv;
	}
	
	
	@RequestMapping(value="/moments",produces=MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody Moments getContactsInJSON(){
		Trader trader = new Trader();
		List<Moment> moment = ifacadeService.query(trader, "from Moment");
		Moments moments=new Moments();
//		moments.setMoments(moment);
		moments.setTname("towne");
		return moments;
	}
	
	@RequestMapping(value="/list/{jparam}",produces=MediaType.APPLICATION_JSON_VALUE)
	public @ResponseBody Moment tetete(@PathVariable(value="jparam") String jp)
	{
		System.out.println(jp); 
		Moment ctt = (Moment) GsonUtil.jsonToModel(jp,Moment.class);
//		List<Contact> ss =  (List<Contact>) GsonUtil.getJsonValue(jp, "contacts");
		Map<?, ?> map = GsonUtil.jsonToMap(jp);
		System.out.println(map.get("trader"));
		Trader trader = (Trader) GsonUtil.getJsonValue(jp, "trader", Trader.class);
	     ; 
		System.out.println(trader);
//		return trader;
		return ctt;
	}
	
}
