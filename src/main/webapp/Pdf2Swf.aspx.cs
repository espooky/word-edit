using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Diagnostics;
using System.IO;

public partial class Pdf2Swf : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        string sWebPath = Request.MapPath("");
        string sFile = sWebPath + "\\" + TextBox1.Text;
        string dFile = sFile.Replace(".pdf", ".swf");
        if (!File.Exists(dFile))
        {
            if (!Doc2Swf("c:\\swftools\\pdf2swf.exe", sFile, dFile))
            {
                Response.Write("该文档被加密,不能转换!");
            }
        }
    }
    /// <summary>
    /// 将pdf等转换为swf文件
    /// </summary>
    /// <param name="appPath">转换程序路径</param>
    /// <param name="Source">源文件</param>
    /// <param name="Des">目标文件</param>
    /// <returns></returns>
    private Boolean Doc2Swf(string appPath, string Source, string Des)
    {
        Process pc = new Process();
        ProcessStartInfo psi = new ProcessStartInfo(appPath, Source + " " + Des);
        try
        {
            pc.StartInfo = psi;
            pc.Start();
            pc.WaitForExit();
        }
        catch
        {
            return false;
            throw;
        }
        finally
        {
            pc.Close();
        }
        return File.Exists(Des);
    }
}