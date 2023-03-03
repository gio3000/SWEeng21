using Microsoft.EntityFrameworkCore;

namespace RESTful_API.Models
{
    [Keyless]
    public class LecturerLectureRel
    {
        public int LecturerID { get; set; }
        public int LectureID { get; set; }
    }
}
