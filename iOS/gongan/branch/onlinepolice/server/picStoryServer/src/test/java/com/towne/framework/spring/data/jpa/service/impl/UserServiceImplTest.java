package com.towne.framework.spring.data.jpa.service.impl;


//@ContextConfiguration(locations={"classpath:beans.xml"})
//@RunWith(value=SpringJUnit4ClassRunner.class)
public class UserServiceImplTest {
	
	/*@Resource(name="userServiceImpl")
	private UserService userService;
	
	@Test
	public void findUserById(){
		User user = userService.findUserById(1);
		System.out.println(user);
	}
	
	@Test
	public void save(){
		
		User user=new User();
		user.setUsername("��xx");
		Dept dept=new Dept();
		dept.setDeptname("�Ļ���");
		user.setDept(dept);
		
		User u = userService.save(user);
		Assert.notNull(u);
		
	}
	
	@Test
	public void modifyById(){
		User user = userService.findUserById(1);
		user.setUsername("С��");
		userService.modifyById("С��",1);
	}
	
	@Test
	public void modifyUser(){
		
		User user = userService.findUserById(1);
		user.setUsername("С��");
		Dept dept=user.getDept();
		dept.setDeptname("�з���");
		user.setDept(dept);
		userService.modifyUser(user);
		
	}
	
	@Test
	public void deleteByUser(){
		
	}
	
	@Test
	public void deleteByUserId(){
		
	}
	
	
	@Test
	public void findByUsernameLike(){
		List<User> lists = userService.findByUsernameLike("С");
		for (User user : lists) {
			System.out.println(user);
			System.out.println("-----------------------");
		}
	}
	
	@Test
	public void findByIdLessThan(){
		List<User> lists = userService.findByIdLessThan(100);
		for (User user : lists) {
			System.out.println(user);
			System.out.println("-----------------------");
		}
	}
	
	*//**
	 * ����username��ѯ ����id��������
	 * @param username
	 * @return
	 *//*
	@Test
	public void findByUsernameLikeOrderByIdDesc(){
		List<User> lists = userService.findByUsernameLikeOrderByIdDesc("С");
		for (User user : lists) {
			System.out.println(user);
			System.out.println("-----------------------");
		}
	}
	
	
	@Test
	public void findByIdBetween(){
		List<User> lists = userService.findByIdBetween(1,10);
		for (User user : lists) {
			System.out.println(user);
			System.out.println("-----------------------");
		}
	}
	
	
	@Test
	public void findUserByDeptId(){
		List<User> lists = userService.findUserByDeptId(1);
		for (User user : lists) {
			System.out.println(user);
			System.out.println("-----------------------");
		}
	}*/
	
}
