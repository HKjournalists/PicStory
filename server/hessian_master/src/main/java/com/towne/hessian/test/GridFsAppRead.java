package com.towne.hessian.test;

import java.io.IOException;
import java.util.List;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.GenericXmlApplicationContext;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.data.mongodb.gridfs.GridFsOperations;

/**
 * GridFs example
 * 
 * @author mkyong
 * 
 */

public class GridFsAppRead {

	public static void main(String[] args) {

		ApplicationContext ctx = new GenericXmlApplicationContext("applicationContext.xml");
		GridFsOperations gridOperations = (GridFsOperations) ctx.getBean("gridFsTemplate");

		List<GridFSDBFile> result = gridOperations.find(new Query().addCriteria(Criteria.where(
				"filename").is("QQ20130428-15.png")));
		for (GridFSDBFile file : result) {
			try {
				System.out.println(file.getFilename());
				System.out.println(file.getContentType());
				
				//save as another image
				file.writeTo("/Users/towne/Desktop/new-testing.png");
			} catch (IOException e) {
				e.printStackTrace();
			}
		}

		System.out.println("Done");

	}

}
