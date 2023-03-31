using Microsoft.EntityFrameworkCore;

namespace RESTful_API.Models
{
    [Keyless]
    public class LecturerLectureRel
    {
        public int LecturerID { get; set; }
<<<<<<< Updated upstream
        public int LectureID { get; set; }
=======
        public Lecturer? Lecturer { get; set; }
        public int LectureID { get; set; }
        public Lecture? Lecture { get; set; }
>>>>>>> Stashed changes
    }
}
