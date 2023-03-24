namespace RESTful_API.Models
{
    public class Exam
    {
        public int ExamID { get; set; }
        public int StudentID { get; set; }
        public Student? Student { get; set; }
        public int LectureID { get; set; }
        public Lecture? Lecture { get; set; }
        public int First_Try { get; set; }
        public int Second_Try { get; set; }
        public int Third_Try { get; set; }
    }
}
