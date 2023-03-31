<<<<<<< Updated upstream
﻿namespace RESTful_API.Models
=======
﻿using System.Text.Json.Serialization;

namespace RESTful_API.Models
>>>>>>> Stashed changes
{
    public class Course
    {
        public int CourseID { get; set; }
        public string? CourseName { get; set; }
<<<<<<< Updated upstream
=======

        public int SecretaryID { get; set; }
        public Secretary? Secretary { get; set; }

        [JsonIgnore]
        public virtual IList<CourseModuleRel>? CourseModuleRels { get; set; }
        [JsonIgnore]
        public virtual ICollection<Student>? Students { get; set; }
>>>>>>> Stashed changes
    }
}
