using Microsoft.EntityFrameworkCore;

namespace RESTful_API.Models
{
    [Keyless]
    public class CourseModuleRel
    {
        public int CourseID { get; set; }
        public int ModuleID { get; set; }
    }
}
