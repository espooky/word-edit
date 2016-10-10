<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="java.io.File"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.io.BufferedInputStream"%>
<%@page import="java.io.BufferedOutputStream"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="org.apache.commons.fileupload.util.Streams"%>
<%
	try{
		// 解析 request，判断是否有上传文件   
		boolean isMultipart = ServletFileUpload.isMultipartContent(request);
		System.out.println("---------"+isMultipart);
		if (isMultipart) {
	
			Date date = new Date();//获取当前时间
			SimpleDateFormat sdfFolder = new SimpleDateFormat("yyMM");
			String fileRealPath = "";//文件存放真实地址
			
			String fileRealResistPath = "";//文件存放真实相对路径
			String id="1";//id
			String docUrl=""; //路径
			String firstFileName="";
			
			String yyMM = sdfFolder.format(date);
			
			//上传文件夹绝对路径
			String physicsPath = request.getRealPath("")
					+ "\\upload\\" + yyMM + "\\";
	
			File file = new File(physicsPath);
			if (!file.isDirectory()) {
				file.mkdir();
			}
	
			// 创建磁盘工厂，利用构造器实现内存数据储存量和临时储存路径 
			DiskFileItemFactory factory = new DiskFileItemFactory();
			// 设置最多只允许在内存中存储的数据,单位:字节   
			// factory.setSizeThreshold(4096);   
			// 设置文件临时存储路径   
			// factory.setRepository(new File("D:\\Temp"));   
			// 产生一新的文件上传处理程式   
			ServletFileUpload upload = new ServletFileUpload(factory);
			// 设置路径、文件名的字符集   
			upload.setHeaderEncoding("UTF-8");
			// 设置允许用户上传文件大小,单位:字节   
			upload.setSizeMax(-1);
			//upload.setSizeMax(1024 * 1024);
			// 解析请求，开始读取数据   
			// Iterator<FileItem> iter = (Iterator<FileItem>) upload.getItemIterator(request);   
			// 得到所有的表单域，它们目前都被当作FileItem  
			BufferedInputStream in = null;
			List fileItems = upload.parseRequest(request);
			// 依次处理请求   
			Iterator iter = fileItems.iterator();
			while (iter.hasNext()) {
				FileItem item = (FileItem) iter.next();
				if (item.isFormField()) {
					// 如果item是正常的表单域   
					String name = item.getFieldName();
					String value = item.getString("UTF-8");
					if(name.equals("id"))
						id=value;//附件标题赋值
					else if(name.equals("docUrl"))
						docUrl=value;//附件ID赋值
				} else {
					// 如果item是文件上传表单域   
					// 获得文件名及路径   
					String fileName = item.getName();
					if (fileName != null) {
						firstFileName=item.getName().substring(item.getName().lastIndexOf("\\")+1);
						in = new BufferedInputStream(item.getInputStream());// 获得文件输入流
					}
				}
			}
			String formatName = firstFileName.substring(firstFileName.lastIndexOf("."));//获取文件后缀名	
			if(docUrl != null && !"".equals(docUrl.trim())){
				fileRealPath = request.getRealPath("") + "\\word\\" + docUrl;//文件存放真实地址
			}else{
				fileRealPath = physicsPath + id+ formatName;//文件存放真实地址
				docUrl = yyMM + "/" + id + formatName;
			}
			BufferedOutputStream outStream = new BufferedOutputStream(new FileOutputStream(new File(fileRealPath)));// 获得文件输出流
			Streams.copy(in, outStream, true);// 开始把文件写到你指定的上传文件夹			
	 
			//上传成功，则插入数据库
			if (new File(fileRealPath).exists()) {
				//虚拟路径赋值
				fileRealResistPath=sdfFolder.format(date)+"/"+fileRealPath.substring(fileRealPath.lastIndexOf("\\")+1);
				//DB db=new DB();
				//System.out.println("!!!"+(String) session.getAttribute("fpsssn")+"&&"+v07.can.myname(session));
				//int count = db.executeUpdate("update   zy_zsytp  set  docurl ='"+docUrl+"'  where  id ='"+id+"'");
				//if(count>0){
				//	response.setContentType("text/html;charset=UTF-8");
				//	out.print("<script>alert('上传成功！');</script>");
				//}
				//db.destroy();
				
				//保存到数据库
			}
		}
	}catch(Exception e){
		e.printStackTrace();
		//response.setContentType("text/html;charset=UTF-8");
		//out.print("<script>window.alert('上传失败！文件大小超过1MB！');</script>");
	}
	
%>

