using Microsoft.EntityFrameworkCore;

namespace RESTful_API.Models
{
    public partial class DatabaseContext : DbContext
    {
        public DatabaseContext()
        {
        }

        public DatabaseContext(DbContextOptions<DatabaseContext> options) : base(options)
        {
        }

        public virtual DbSet<User>? Users { get; set; }
        public virtual DbSet<Admin> Admins { get; set; }
        public virtual DbSet<Course> Courses { get; set; }
        public virtual DbSet<Exam> Exams { get; set; }
        public virtual DbSet<Lecture> Lectures { get; set; }
        public virtual DbSet<Module> Modules { get; set; }
        public virtual DbSet<Student> Students { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            // User table
            modelBuilder.Entity<User>(entity =>
            {
                entity.ToTable("User");
                entity.Property(e => e.UserID).HasColumnName("UserID");
                entity.Property(e => e.First_Name).HasMaxLength(40).IsUnicode(true);
                entity.Property(e => e.Last_Name).HasMaxLength(40).IsUnicode(true);
                entity.Property(e => e.Email).HasMaxLength(60).IsUnicode(true);
                entity.Property(e => e.Hash_Count).IsUnicode(false);
                entity.Property(e => e.Salt).HasMaxLength(32).IsUnicode(true);
                entity.Property(e => e.Password).HasMaxLength(64).IsUnicode(true);
            });

            // Admin table
            modelBuilder.Entity<Admin>(entity =>
            {
                entity.ToTable("Admin");
                entity.Property(e => e.AdminID).HasColumnName("AdminID");
                entity.Property(e => e.UserID).IsUnicode(false);
            });
            modelBuilder.Entity<Admin>().HasOne<User>().WithMany().HasForeignKey(e => e.UserID);

            // Course table
            modelBuilder.Entity<Course>(enitiy =>
            {
                enitiy.ToTable("Course");
                enitiy.Property(e => e.CourseID).HasColumnName("CourseID");
                enitiy.Property(e => e.CourseName).HasMaxLength(10).IsUnicode(true);
            });

            // CourseModuleRel table

            // Exam table
            modelBuilder.Entity<Exam>(enitiy =>
            {
                enitiy.ToTable("Exam");
                enitiy.Property(e => e.ExamID).HasColumnName("ExamID");
                enitiy.Property(e => e.LectureID).IsUnicode(false);
                enitiy.Property(e => e.StudentID).IsUnicode(false);
                enitiy.Property(e => e.Grade).IsUnicode(false);
                enitiy.Property(e => e.Semester).HasMaxLength(20).IsUnicode(true);
                enitiy.Property(e => e.CountToAverage).IsUnicode(false);
            });
            modelBuilder.Entity<Exam>().HasOne<Lecture>().WithMany().HasForeignKey(e => e.LectureID);
            modelBuilder.Entity<Exam>().HasOne<Student>().WithMany().HasForeignKey(e => e.StudentID);

            // Lecture table
            modelBuilder.Entity<Lecture>(enitiy =>
            {
                enitiy.ToTable("Lecture");
                enitiy.Property(e => e.LectureID).HasColumnName("LectureID");
                enitiy.Property(e => e.ModuleID).IsUnicode(false);
                enitiy.Property(e => e.LectureName).HasMaxLength(40).IsUnicode(true);
            });
            modelBuilder.Entity<Lecture>().HasOne<Module>().WithMany().HasForeignKey(e => e.ModuleID);

            // Lecturer table

            // LecturerLectureRel table

            // Module table
            modelBuilder.Entity<Module>(enitiy =>
            {
                enitiy.ToTable("Module");
                enitiy.Property(e => e.ModuleID).HasColumnName("ModuleID");
                enitiy.Property(e => e.ModuleName).HasMaxLength(40).IsUnicode(true);
                enitiy.Property(e => e.CTS).IsUnicode(false);
                enitiy.Property(e => e.Status).HasMaxLength(20).IsUnicode(true);
            });

            // Secretary table

            // Student table
            modelBuilder.Entity<Student>(enitiy =>
            {
                enitiy.ToTable("Student");
                enitiy.Property(e => e.StudentID).HasColumnName("StudentID");
                enitiy.Property(e => e.CourseID).IsUnicode(false);
                enitiy.Property(e => e.UserID).IsUnicode(false);
                enitiy.Property(e => e.MatriculationNr).IsUnicode(false);
            });
            modelBuilder.Entity<Student>().HasOne<User>().WithMany().HasForeignKey(e => e.UserID);
            modelBuilder.Entity<Student>().HasOne<Course>().WithMany().HasForeignKey(e => e.CourseID);

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
