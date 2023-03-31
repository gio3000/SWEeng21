using RESTful_API.Models;

namespace RESTful_API.Interface
{
    public interface IExam
    {
        public List<Exam> GetExams();
        public Exam GetExam(int id);
        public void AddExam(Exam exam);
        public void UpdateExam(Exam exam);
        public Exam DeleteExam(int id);
        public bool CheckExam(int id);
    }
}
