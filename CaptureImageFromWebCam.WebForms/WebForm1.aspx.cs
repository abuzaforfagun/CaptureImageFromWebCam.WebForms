using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CaptureImageFromWebCam.WebForms
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        string url;
        string imgUrl;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!this.IsPostBack)
            {
                if (Request.InputStream.Length > 0)
                {
                    using (StreamReader reader = new StreamReader(Request.InputStream))
                    {
                        string hexString = Server.UrlEncode(reader.ReadToEnd());
                        string imageName = DateTime.Now.ToString("dd-MM-yy hh-mm-ss");
                        string imagePath = string.Format("~/Captures/{0}.png", imageName);
                        File.WriteAllBytes(Server.MapPath(imagePath), ConvertHexToBytes(hexString));
                        Session["CapturedImage"] = ResolveUrl(imagePath);
                        imgUrl = imagePath;
                    }
                }
            }
        }

        private static byte[] ConvertHexToBytes(string hex)
        {
            byte[] bytes = new byte[hex.Length / 2];
            for (int i = 0; i < hex.Length; i += 2)
            {
                bytes[i / 2] = Convert.ToByte(hex.Substring(i, 2), 16);
            }
            return bytes;
        }

        [WebMethod(EnableSession = false)]
        public static string GetCapturedImage()
        {
            string url = HttpContext.Current.Session["CapturedImage"].ToString();
            
            HttpContext.Current.Session["CapturedImage"] = null;
            HttpContext.Current.Session["CapturedImageFinal"] = url;
            return url;
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            string connString = ConfigurationManager.ConnectionStrings["HRMDb"].ToString();
            string sql = $"INSERT INTO Users (name, email, photo) values ('{txtName.Text}', '{txtEmail.Text}', '{HttpContext.Current.Session["CapturedImageFinal"].ToString()}')";

            SqlConnection conn = new SqlConnection(connString);
            SqlCommand cmd = new SqlCommand(sql, conn);
            conn.Open();

            // create data adapter
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            cmd.ExecuteNonQuery();
        }
    }
}