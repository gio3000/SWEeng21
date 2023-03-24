using System.Text.Json.Serialization;

namespace RESTful_API.Models
{
    public class Secretary
    {
        public int SecretaryID { get; set; }
        public int UserID { get; set; }
        public User? User { get; set; }
        public string? Name { get; set; }

        [JsonIgnore]
        public virtual ICollection<Course>? Courses { get; set; }
    }
}
