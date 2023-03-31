<<<<<<< Updated upstream
﻿namespace RESTful_API.Models
=======
﻿using System.Text.Json.Serialization;

namespace RESTful_API.Models
>>>>>>> Stashed changes
{
    public class Lecturer
    {
        public int LecturerID { get; set; }
        public int UserID { get; set; }
<<<<<<< Updated upstream
=======
        public User? User { get; set; }

        [JsonIgnore]
        public virtual IList<LecturerLectureRel>? LecturerLectureRels { get; set; }
>>>>>>> Stashed changes
    }
}
