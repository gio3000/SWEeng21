using System.Text.Json.Serialization;

namespace RESTful_API.Models
{
    public class Module
    {
        public int ModuleID { get; set; }
        public string? ModuleName { get; set; }    
        public int CTS { get; set; }
        public string? Status { get; set;}

        [JsonIgnore]
        public virtual IList<CourseModuleRel>? CourseModuleRels { get; set; }
    }
}
