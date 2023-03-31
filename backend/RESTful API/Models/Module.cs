<<<<<<< Updated upstream
﻿namespace RESTful_API.Models
=======
﻿using System.Text.Json.Serialization;

namespace RESTful_API.Models
>>>>>>> Stashed changes
{
    public class Module
    {
        public int ModuleID { get; set; }
        public string? ModuleName { get; set; }    
        public int CTS { get; set; }
<<<<<<< Updated upstream
        public string? Status { get; set;}
=======

        [JsonIgnore]
        public virtual IList<CourseModuleRel>? CourseModuleRels { get; set; }

        [JsonIgnore]
        public virtual ICollection<Lecture>? Lectures { get; set; }
>>>>>>> Stashed changes
    }
}
