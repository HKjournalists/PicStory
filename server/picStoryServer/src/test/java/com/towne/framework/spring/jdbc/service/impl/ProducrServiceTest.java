 package com.towne.framework.spring.jdbc.service.impl;

import javax.annotation.Resource;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.towne.framework.spring.jdbc.model.Product;
import com.towne.framework.spring.jdbc.service.ProductService;



@ContextConfiguration(value="classpath:spring-jdbc.xml")
//@RunWith(value=SpringJUnit4ClassRunner.class)
public class ProducrServiceTest {
	/*
	@Resource(name="jdbcProductServiceImpl")
	ProductService productService;
	

	@Test
	public void save(){
		Product product=new Product();
		product.setName("SONY 3D TV");
		product.setPrice(79.0f);
		product.setDescription("SONY");
		product.setCategoryid("3");
		productService.save(product);
	}
	

	@Test
	public void getProduct(){
		Product product=productService.findById(3);
		System.out.println(product.getName()+"\t"+product.getDescription());
	}
	
	@Test
	public void getProductListByCategory(){
		List<Product> lists=productService.getProductListByCategory("家电");
		for (Product product : lists) {
			System.out.println(product.getName()+"\t"+product.getDescription()+"\t"+product.getCategoryid());
		}
	}
	
	
	@Test
	public void listAll(){
		List<Product> lists=productService.listAll();
		for (Product product : lists) {
			System.out.println(product.getName()+"\t"+product.getDescription()+"\t"+product.getCategoryid());
		}
	}*/
}
