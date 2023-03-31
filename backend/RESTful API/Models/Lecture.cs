<<<<<<< Updated upstream
﻿namespace RESTful_API.Models
=======
﻿using System.Text.Json.Serialization;

namespace RESTful_API.Models
>>>>>>> Stashed changes
{
    public class Lecture
    {
        public int LectureID { get; set; }
<<<<<<< Updated upstream
        public int ModuleID { get; set; }
        public string? LectureName { get;set; }
=======

        public int ModuleID { get; set; }
        public Module? Module { get; set; }

        public string? LectureName { get;set; }
        public int CountsToAverage { get; set; }
        public string? Semester { get; set; }

        [JsonIgnore]
        public virtual ICollection<Exam>? Exams { get; set; }
        [JsonIgnore]
        public virtual IList<LecturerLectureRel>? LecturerLectureRels { get; set; }
        
        
>>>>>>> Stashed changes
    }
}
