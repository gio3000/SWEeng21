using Microsoft.EntityFrameworkCore;

namespace RESTful_API.Models
{
    [Keyless]
    public class CourseModuleRel
    {
        public int CourseID { get; set; }
<<<<<<< Updated upstream
        public int ModuleID { get; set; }
=======
        public Course? Course { get; set; }

        public int ModuleID { get; set; }
        public Module? Module { get; set; }
>>>>>>> Stashed changes
    }
}
