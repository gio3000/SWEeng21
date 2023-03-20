using System.Text.Json.Serialization;

namespace RESTful_API.Models
{
    public class Lecturer
    {
        public int LecturerID { get; set; }
        public int UserID { get; set; }
        public User? User { get; set; }

        [JsonIgnore]
        public virtual IList<LecturerLectureRel>? LecturerLectureRels { get; set; }
    }
}
