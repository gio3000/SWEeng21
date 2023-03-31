<<<<<<< Updated upstream
﻿namespace RESTful_API.Models
=======
﻿using System.Text.Json.Serialization;

namespace RESTful_API.Models
>>>>>>> Stashed changes
{
    public class Student
    {
        public int StudentID { get; set; }
        public int CourseID { get; set; }
<<<<<<< Updated upstream
        public int UserID { get; set; }
        public int MatriculationNr { get; set; }
=======
        public Course? Course { get; set; }
        public int UserID { get; set; }
        public User? User { get; set; }
        public int MatriculationNr { get; set; }

        [JsonIgnore]
        public virtual ICollection<Exam>? Exams { get; set; }
>>>>>>> Stashed changes
    }
}
