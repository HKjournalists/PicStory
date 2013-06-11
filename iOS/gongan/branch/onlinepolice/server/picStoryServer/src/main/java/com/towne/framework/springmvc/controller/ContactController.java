package com.towne.framework.springmvc.controller;

import java.util.List;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.servlet.ModelAndView;

import com.towne.framework.spring.data.jpa.service.ContactService;
import com.towne.framework.springmvc.model.Contact;

@Controller(value="contactController")
@SessionAttributes
public class ContactController {
	
	@Autowired
	ContactService contactService;
	
	public static final int PAGE_SIZE=5; 
	public static final int PAGE_NUMBER=0; 
	
	
	/**
	 * ��ӷ���
	 * @param contact
	 * @param result
	 * @return
	 */
	@RequestMapping(value="/add",method=RequestMethod.POST)
	public String addContact(@ModelAttribute(value="model") @Valid Contact contact,BindingResult result){
		
		if(result.hasErrors()){
			return "contact";
		}else{
			//System.out.println("First Name:" + contact.getFirstname() + "Last Name:" + contact.getLastname());
			//HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.getRequestAttributes()).getRequest();
			contactService.save(contact);
			return "redirect:/listAll.do";
		}
	}
	
	
	/**
	 * 
	 * @return
	 */
	@RequestMapping(value="/npage",method=RequestMethod.GET)
	public ModelAndView newModelPage(){
		return new ModelAndView("contact","model",new Contact());//��ת��contact.jsp ģ�͵�����Ϊmodel
	}
	
	
	/**
	 * ��ѯ���з���json��
	 * @param contact
	 * @param result
	 * @return
	 */
	@RequestMapping(value="/ajson",method=RequestMethod.GET)
	public @ResponseBody List<Contact> alltoJson(@ModelAttribute(value="contact") Contact contact,BindingResult result){
		List<Contact> contacts = contactService.listAll();
		return contacts;
	}
	
	
	
	/**
	 * �޸�ʱ��ת
	 * @param id
	 * @return
	 */
	@RequestMapping(value="/modify/{id}")
	public ModelAndView modifyPage(@PathVariable(value="id")Integer id){
		Contact contact = contactService.findById(id);
		ModelAndView modelAndView=new ModelAndView();
		modelAndView.setViewName("modifycontact");//��ת��modifycontact.jsp
		modelAndView.addObject("model", contact);//ģ�͵�����model
		return modelAndView;
	}
	
	
	
	/**
	 * �޸�ʱ��ת
	 * @param id
	 * @return
	 */
	@RequestMapping(value="/listAll/{pageNumber}/{pageSize}")
	public ModelAndView listAll(@PathVariable(value="pageNumber") int pageNumber,@PathVariable(value="pageSize") int pageSize){
		
		if(pageNumber<0){
			pageNumber=PAGE_NUMBER;
		}
		if(pageSize<0){
			pageSize=PAGE_SIZE;
		}
		
		PageRequest pageRequest=new PageRequest(pageNumber, pageSize);
		
		Page<Contact> pagingdata = contactService.findAll(pageRequest);
		ModelAndView modelAndView=new ModelAndView();
		modelAndView.setViewName("list");//��ת��list.jsp
		modelAndView.addObject("alllist", pagingdata.getContent());
		modelAndView.addObject("number", pagingdata.getNumber());
		modelAndView.addObject("size", pagingdata.getSize());
		modelAndView.addObject("totalElements", pagingdata.getTotalElements());
		modelAndView.addObject("totalPages", pagingdata.getTotalPages());
		return modelAndView;
	}
	
	
	
	/**
	 * ɾ��
	 * @param id
	 * @return
	 */
	@RequestMapping(value="/del/{id}")
	public String del(@PathVariable(value="id")int id){
		contactService.delete(id);
		return "redirect:/listAll.do";
	}
	
	
	
	/**
	 * ��ѯ����С��ĳһֵ ���Ұ�Id��������
	 * @param id
	 * @return
	 */
	@RequestMapping(value="/listAll/{age}/{pageNumber}/{pageSize}")
	public ModelAndView findByAgeLessThanOrderByIdDesc(@PathVariable(value="pageNumber") int pageNumber,@PathVariable(value="pageSize") int pageSize,@PathVariable(value="age") int age){
		
		if(pageNumber<0){
			pageNumber=PAGE_NUMBER;
		}
		if(pageSize<0){
			pageSize=PAGE_SIZE;
		}
		
		PageRequest pageRequest=new PageRequest(pageNumber, pageSize);
		
		Page<Contact> pagingdata = contactService.findByAgeLessThanEqualOrderByIdDesc(age, pageRequest);
		ModelAndView modelAndView=new ModelAndView();
		modelAndView.setViewName("list");//��ת��list.jsp
		modelAndView.addObject("alllist", pagingdata.getContent());
		modelAndView.addObject("number", pagingdata.getNumber()+1);
		modelAndView.addObject("size", pagingdata.getSize());
		modelAndView.addObject("totalElements", pagingdata.getTotalElements());
		modelAndView.addObject("totalPages", pagingdata.getTotalPages());
		return modelAndView;
	}
	
	
}
