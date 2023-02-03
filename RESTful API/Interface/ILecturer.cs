using RESTful_API.Models;

namespace RESTful_API.Interface
{
    public interface ILecturer
    {
        public List<Lecturer> GetLecturers();
        public Lecturer GetLecturer(int id);
        public void AddLecturer(Lecturer lecturer);
        public void UpdateLecturer(Lecturer lecturer);
        public Lecturer DeleteLecturer(int id);
        public bool CheckLecturer(int id);
    }
}
