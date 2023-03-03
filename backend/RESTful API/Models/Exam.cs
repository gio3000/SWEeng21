namespace RESTful_API.Models
{
    public class Exam
    {
        public int ExamID { get; set; }
        public int StudentID { get; set; }
        public Student? Student { get; set; }
        public int LectureID { get; set; }
        public Lecture? Lecture { get; set; }
        public double Grade { get; set; }
        public string? Semester { get; set;}
        public bool? CountToAverage { get; set; }
    }
}
