using System.Text.Json.Serialization;

namespace RESTful_API.Models
{
    public class Course
    {
        public int CourseID { get; set; }
        public string? CourseName { get; set; }

        public int SecretaryID { get; set; }
        public Secretary? Secretary { get; set; }

        [JsonIgnore]
        public virtual IList<CourseModuleRel>? CourseModuleRels { get; set; }
        [JsonIgnore]
        public virtual ICollection<Student>? Students { get; set; }
    }
}
