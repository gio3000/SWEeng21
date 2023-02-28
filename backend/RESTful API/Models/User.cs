﻿using System.Text.Json.Serialization;

namespace RESTful_API.Models
{
    public class User
    {
        public int UserID { get; set; }
        public string? First_Name { get; set; }
        public string? Last_Name { get; set; }
        public string? Email { get; set; }
        public string? Password { get; set; }
        public string? Salt { get; set; }
        public int Hash_Count { get; set; }

        [JsonIgnore]
        public virtual ICollection<Admin>? Admins { get; set; }
    }
}
