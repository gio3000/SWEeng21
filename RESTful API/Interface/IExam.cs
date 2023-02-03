using RESTful_API.Models;

namespace RESTful_API.Interface
{
    public interface IExam
    {
        public List<Exam> GetExams();
        public User GetExam(int id);
        public void AddExam(User user);
        public void UpdateExam(User user);
        public User DeleteExam(int id);
        public bool CheckExam(int id);
    }
}
