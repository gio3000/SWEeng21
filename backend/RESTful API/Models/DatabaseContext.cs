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
<<<<<<< Updated upstream
                entity.Property(e => e.Email).HasMaxLength(60).IsUnicode(true);
                entity.Property(e => e.Hash_Count).IsUnicode(false);
                entity.Property(e => e.Salt).HasMaxLength(32).IsUnicode(true);
                entity.Property(e => e.Password).HasMaxLength(64).IsUnicode(true);
=======
                entity.Property(e => e.Role).HasConversion<string>().IsUnicode(false);
                entity.Property(e => e.Email).HasMaxLength(60).IsUnicode(true);
                entity.Property(e => e.Password).HasMaxLength(64).IsUnicode(true);
                entity.Property(e => e.Initial_Password).HasMaxLength(64).IsUnicode(true);
                entity.Property(e => e.Salt).HasMaxLength(32).IsUnicode(true);
                entity.Property(e => e.Initial_Salt).HasMaxLength(32).IsUnicode(true);
                entity.Property(e => e.Hash_Count).IsUnicode(false);

>>>>>>> Stashed changes
            });

            // Admin table
            modelBuilder.Entity<Admin>(entity =>
            {
                entity.ToTable("Admin");
                entity.Property(e => e.AdminID).HasColumnName("AdminID");
                entity.Property(e => e.UserID).IsUnicode(false);
            });
            modelBuilder.Entity<Admin>()
<<<<<<< Updated upstream
                .HasOne(u => u.User)
                .WithMany(a => a.Admins)
=======
                .HasOne<User>(a => a.User)
                .WithMany(u => u.Admins)
>>>>>>> Stashed changes
                .HasForeignKey(a => a.UserID);

            // Course table
            modelBuilder.Entity<Course>(entity =>
            {
                entity.ToTable("Course");
                entity.Property(e => e.CourseID).HasColumnName("CourseID");
                entity.Property(e => e.CourseName).HasMaxLength(10).IsUnicode(true);
<<<<<<< Updated upstream
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
=======
                entity.Property(e => e.SecretaryID).IsUnicode(false);
            });

            modelBuilder.Entity<Course>()
                .HasOne<Secretary>(c => c.Secretary)
                .WithMany(s => s.Courses)
                .HasForeignKey(c => c.SecretaryID);

            // CourseModuleRel table
            modelBuilder.Entity<CourseModuleRel>().HasKey(cm => new { cm.CourseID, cm.ModuleID });

            modelBuilder.Entity<CourseModuleRel>()
                .HasOne<Course>(cm => cm.Course)
                .WithMany(c => c.CourseModuleRels)
                .HasForeignKey(cm => cm.CourseID);


            modelBuilder.Entity<CourseModuleRel>()
                .HasOne<Module>(cm => cm.Module)
                .WithMany(m => m.CourseModuleRels)
                .HasForeignKey(cm => cm.ModuleID);
>>>>>>> Stashed changes

            // Exam table
            modelBuilder.Entity<Exam>(entity =>
            {
                entity.ToTable("Exam");
                entity.Property(e => e.ExamID).HasColumnName("ExamID");
                entity.Property(e => e.LectureID).IsUnicode(false);
                entity.Property(e => e.StudentID).IsUnicode(false);
<<<<<<< Updated upstream
                entity.Property(e => e.Grade).IsUnicode(false);
                entity.Property(e => e.Semester).HasMaxLength(20).IsUnicode(true);
                entity.Property(e => e.CountToAverage).IsUnicode(false);
            });
            modelBuilder.Entity<Exam>().HasOne<Lecture>().WithMany().HasForeignKey(e => e.LectureID);
            modelBuilder.Entity<Exam>().HasOne<Student>().WithMany().HasForeignKey(e => e.StudentID);
=======
                entity.Property(e => e.First_Try).IsUnicode(false).HasDefaultValue(null);
                entity.Property(e => e.Second_Try).IsUnicode(false).HasDefaultValue(null);
                entity.Property(e => e.Third_Try).IsUnicode(false).HasDefaultValue(null);
            });
            modelBuilder.Entity<Exam>()
                .HasOne<Lecture>(e => e.Lecture)
                .WithMany(l => l.Exams)
                .HasForeignKey(e => e.LectureID);

            modelBuilder.Entity<Exam>()
                .HasOne<Student>(e => e.Student)
                .WithMany(s => s.Exams)
                .HasForeignKey(e => e.StudentID);
>>>>>>> Stashed changes

            // Lecture table
            modelBuilder.Entity<Lecture>(entity =>
            {
                entity.ToTable("Lecture");
                entity.Property(e => e.LectureID).HasColumnName("LectureID");
                entity.Property(e => e.ModuleID).IsUnicode(false);
                entity.Property(e => e.LectureName).HasMaxLength(40).IsUnicode(true);
<<<<<<< Updated upstream
            });
            modelBuilder.Entity<Lecture>().HasOne<Module>().WithMany().HasForeignKey(e => e.ModuleID);
=======
                entity.Property(e => e.CountsToAverage).IsUnicode(false);
                entity.Property(e => e.Semester).HasMaxLength(40).IsUnicode(true);
            });
            modelBuilder.Entity<Lecture>()
                .HasOne<Module>(l => l.Module)
                .WithMany(m => m.Lectures)
                .HasForeignKey(l => l.ModuleID);
>>>>>>> Stashed changes

            // Lecturer table
            modelBuilder.Entity<Lecturer>(entity =>
            {
                entity.ToTable("Lecturer");
                entity.Property(e => e.LecturerID).HasColumnName("LecturerID");
                entity.Property(e => e.UserID).IsUnicode(false);
            });
<<<<<<< Updated upstream
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
=======
            modelBuilder.Entity<Lecturer>()
                .HasOne<User>(l => l.User)
                .WithMany(u => u.Lecturers)
                .HasForeignKey(l => l.UserID);

            // LecturerLectureRel table
            modelBuilder.Entity<LecturerLectureRel>().HasKey(ll => new { ll.LecturerID, ll.LectureID });

            modelBuilder.Entity<LecturerLectureRel>()
                .HasOne<Lecturer>(ll => ll.Lecturer)
                .WithMany(l => l.LecturerLectureRels)
                .HasForeignKey(ll => ll.LecturerID);

            modelBuilder.Entity<LecturerLectureRel>()
                .HasOne<Lecture>(ll => ll.Lecture)
                .WithMany(l => l.LecturerLectureRels)
                .HasForeignKey(l => l.LectureID);
>>>>>>> Stashed changes

            // Module table
            modelBuilder.Entity<Module>(entity =>
            {
                entity.ToTable("Module");
                entity.Property(e => e.ModuleID).HasColumnName("ModuleID");
                entity.Property(e => e.ModuleName).HasMaxLength(40).IsUnicode(true);
                entity.Property(e => e.CTS).IsUnicode(false);
<<<<<<< Updated upstream
                entity.Property(e => e.Status).HasMaxLength(20).IsUnicode(true);
=======
>>>>>>> Stashed changes
            });

            // Secretary table
            modelBuilder.Entity<Secretary>(entity =>
            {
                entity.ToTable("Secretary");
                entity.Property(e => e.SecretaryID).HasColumnName("SecretaryID");
                entity.Property(e => e.UserID).IsUnicode(false);
                entity.Property(e => e.Name).HasMaxLength(40).IsUnicode(true); 
            });
<<<<<<< Updated upstream
=======
            modelBuilder.Entity<Secretary>()
                .HasOne<User>(s => s.User)
                .WithMany(u => u.Secretaries)
                .HasForeignKey(s => s.UserID);
>>>>>>> Stashed changes

            // Student table
            modelBuilder.Entity<Student>(entity =>
            {
                entity.ToTable("Student");
                entity.Property(e => e.StudentID).HasColumnName("StudentID");
                entity.Property(e => e.CourseID).IsUnicode(false);
                entity.Property(e => e.UserID).IsUnicode(false);
                entity.Property(e => e.MatriculationNr).IsUnicode(false);
            });
<<<<<<< Updated upstream
            modelBuilder.Entity<Student>().HasOne<User>().WithMany().HasForeignKey(e => e.UserID);
            modelBuilder.Entity<Student>().HasOne<Course>().WithMany().HasForeignKey(e => e.CourseID);
=======
            modelBuilder.Entity<Student>()
                .HasOne<User>(s => s.User)
                .WithMany(u => u.Students)
                .HasForeignKey(s => s.UserID);

            modelBuilder.Entity<Student>()
                .HasOne<Course>(s => s.Course)
                .WithMany(c => c.Students)
                .HasForeignKey(s => s.CourseID);
>>>>>>> Stashed changes

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
