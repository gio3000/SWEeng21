using System.Text.Json.Serialization;

namespace RESTful_API.Models
{
    public class Lecture
    {
        public int LectureID { get; set; }
        public int ModuleID { get; set; }
        public string? LectureName { get;set; }

        [JsonIgnore]
        public virtual ICollection<Exam>? Exams { get; set; }
    }
}
