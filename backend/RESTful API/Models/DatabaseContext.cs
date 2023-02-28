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
        public virtual DbSet<CourseModuleRel> CourseModuleRels { get; set; }
        public virtual DbSet<Exam> Exams { get; set; }
        public virtual DbSet<Lecture> Lectures { get; set; }
        public virtual DbSet<Lecturer> Lecturers { get; set; }
        public virtual DbSet<LecturerLectureRel> LecturerLectureRels { get; set; }
        public virtual DbSet<Module> Modules { get; set; }
        public virtual DbSet<Secretary> Secretarys { get; set; }
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
            modelBuilder.Entity<Admin>()
                .HasOne<User>(a => a.User)
                .WithMany(u => u.Admins)
                .HasForeignKey(a => a.UserID);

            // Course table
            modelBuilder.Entity<Course>(entity =>
            {
                entity.ToTable("Course");
                entity.Property(e => e.CourseID).HasColumnName("CourseID");
                entity.Property(e => e.CourseName).HasMaxLength(10).IsUnicode(true);
            });

            // CourseModuleRel table
            modelBuilder.Entity<CourseModuleRel>(entity =>
            {
                entity.ToTable("CourseModuleRel");
                entity.HasNoKey();
                entity.Property(e => e.CourseID).HasColumnName("CourseID");
                entity.Property(e => e.ModuleID).HasColumnName("ModuleID");
            });
            modelBuilder.Entity<CourseModuleRel>().HasOne<Course>().WithMany().HasForeignKey(e => e.CourseID);
            modelBuilder.Entity<CourseModuleRel>().HasOne<Module>().WithMany().HasForeignKey(e => e.ModuleID);

            // Exam table
            modelBuilder.Entity<Exam>(entity =>
            {
                entity.ToTable("Exam");
                entity.Property(e => e.ExamID).HasColumnName("ExamID");
                entity.Property(e => e.LectureID).IsUnicode(false);
                entity.Property(e => e.StudentID).IsUnicode(false);
                entity.Property(e => e.Grade).IsUnicode(false);
                entity.Property(e => e.Semester).HasMaxLength(20).IsUnicode(true);
                entity.Property(e => e.CountToAverage).IsUnicode(false);
            });
            modelBuilder.Entity<Exam>().HasOne<Lecture>().WithMany().HasForeignKey(e => e.LectureID);
            modelBuilder.Entity<Exam>().HasOne<Student>().WithMany().HasForeignKey(e => e.StudentID);

            // Lecture table
            modelBuilder.Entity<Lecture>(entity =>
            {
                entity.ToTable("Lecture");
                entity.Property(e => e.LectureID).HasColumnName("LectureID");
                entity.Property(e => e.ModuleID).IsUnicode(false);
                entity.Property(e => e.LectureName).HasMaxLength(40).IsUnicode(true);
            });
            modelBuilder.Entity<Lecture>().HasOne<Module>().WithMany().HasForeignKey(e => e.ModuleID);

            // Lecturer table
            modelBuilder.Entity<Lecturer>(entity =>
            {
                entity.ToTable("Lecturer");
                entity.Property(e => e.LecturerID).HasColumnName("LecturerID");
                entity.Property(e => e.UserID).IsUnicode(false);
            });
            modelBuilder.Entity<Lecturer>().HasOne<User>().WithMany().HasForeignKey(e => e.UserID);

            // LecturerLectureRel table
            modelBuilder.Entity<LecturerLectureRel>(entity =>
            {
                entity.ToTable("LecturerLectureRel");
                entity.HasNoKey();
                entity.Property(e => e.LecturerID).HasColumnName("LecturerID");
                entity.Property(e => e.LectureID).HasColumnName("LectureID");
            });
            modelBuilder.Entity<LecturerLectureRel>().HasOne<Lecturer>().WithMany().HasForeignKey(e => e.LecturerID);
            modelBuilder.Entity<LecturerLectureRel>().HasOne<Lecture>().WithMany().HasForeignKey(e => e.LectureID);

            // Module table
            modelBuilder.Entity<Module>(entity =>
            {
                entity.ToTable("Module");
                entity.Property(e => e.ModuleID).HasColumnName("ModuleID");
                entity.Property(e => e.ModuleName).HasMaxLength(40).IsUnicode(true);
                entity.Property(e => e.CTS).IsUnicode(false);
                entity.Property(e => e.Status).HasMaxLength(20).IsUnicode(true);
            });

            // Secretary table
            modelBuilder.Entity<Secretary>(entity =>
            {
                entity.ToTable("Secretary");
                entity.Property(e => e.SecretaryID).HasColumnName("SecretaryID");
                entity.Property(e => e.UserID).IsUnicode(false);
                entity.Property(e => e.Name).HasMaxLength(40).IsUnicode(true); 
            });

            // Student table
            modelBuilder.Entity<Student>(entity =>
            {
                entity.ToTable("Student");
                entity.Property(e => e.StudentID).HasColumnName("StudentID");
                entity.Property(e => e.CourseID).IsUnicode(false);
                entity.Property(e => e.UserID).IsUnicode(false);
                entity.Property(e => e.MatriculationNr).IsUnicode(false);
            });
            modelBuilder.Entity<Student>().HasOne<User>().WithMany().HasForeignKey(e => e.UserID);
            modelBuilder.Entity<Student>().HasOne<Course>().WithMany().HasForeignKey(e => e.CourseID);

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
