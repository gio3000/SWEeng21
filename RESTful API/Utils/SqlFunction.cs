using Microsoft.AspNetCore.Mvc;
using System.Data;
using System.Data.SqlClient;

namespace RESTful_API.Utils
{
    public class SqlFunction
    {
        public static JsonResult getSqlQuery(string query)
        {
            try
            {
                SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder();
                builder.DataSource = "31.47.240.136:3306.database.windows.net";
                builder.UserID = "SWENGUser";
                builder.Password = "WkvUqQ2@DpCn";
                builder.InitialCatalog = "SWENGDB";

                SqlDataReader reader;
                DataTable table = new DataTable();

                using (SqlConnection connection = new SqlConnection(builder.ConnectionString))
                {
                    connection.Open();
                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        reader = command.ExecuteReader();
                        table.Load(reader);

                        reader.Close();
                        connection.Close();
                    }
                }

                return new JsonResult(table);
            }
            catch (SqlException e)
            {
                Console.WriteLine(e.ToString());
            }
            return null;
        }
    
    }
}
