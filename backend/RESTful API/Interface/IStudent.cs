using RESTful_API.Models;

namespace RESTful_API.Interface
{
    public interface IStudent
    {
        public List<Student> GetStudents();
        public Student GetStudent(int id);
        public void AddStudent(Student student);
        public void UpdateStudent(Student student);
        public Student DeleteStudent(int id);
        public bool CheckStudent(int id);
    }
}
