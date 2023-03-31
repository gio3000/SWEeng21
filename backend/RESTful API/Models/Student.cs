using System.Text.Json.Serialization;

namespace RESTful_API.Models
{
    public class Student
    {
        public int StudentID { get; set; }
        public int CourseID { get; set; }
        public Course? Course { get; set; }
        public int UserID { get; set; }
        public User? User { get; set; }
        public int MatriculationNr { get; set; }

        [JsonIgnore]
        public virtual ICollection<Exam>? Exams { get; set; }
    }
}
