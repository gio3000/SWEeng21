using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using RESTful_API.Interface;
using RESTful_API.Models;
using RESTful_API.Repository;
using System.Text;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

//Donot forgot to add ConnectionStrings as "dbConnection" to the appsetting.json file
builder.Services.AddDbContext<DatabaseContext>
    (options => options.UseMySQL(builder.Configuration.GetConnectionString("dbConnection")));

// Interface and Repository Mapping
builder.Services.AddTransient<IAdmin, AdminRepository>();
builder.Services.AddTransient<ICourse, CourseRepository>();
builder.Services.AddTransient<ICourseModuleRel, CourseModuleRelRepository>();
builder.Services.AddTransient<IExam, ExamRepository>();
builder.Services.AddTransient<ILecture, LectureRepository>();
builder.Services.AddTransient<ILecturer, LecturerRepository>();
builder.Services.AddTransient<ILecturerLectureRel, LecturerLectureRelRepository>();
builder.Services.AddTransient<IModule, ModuleRepository>();
builder.Services.AddTransient<ISecretary, SecretaryRepository>();
builder.Services.AddTransient<IStudent, StudentRepository>();
builder.Services.AddTransient<IUsers, UserRepository>();

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme).AddJwtBearer(options =>
{
    options.RequireHttpsMetadata = false;
    options.SaveToken = true;
    options.TokenValidationParameters = new TokenValidationParameters()
    {
        ValidateIssuer = true,
        ValidateAudience = true,
        ValidAudience = builder.Configuration["Jwt:Audience"],
        ValidIssuer = builder.Configuration["Jwt:Issuer"],
        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(builder.Configuration["Jwt:Key"]))
    };
});

builder.Services.AddCors(options =>
{
    options.AddPolicy(name: "MyPolicy",
                policy =>
                {
                    policy.WithOrigins("*")
                            .WithHeaders("*")
                            .WithMethods("GET", "POST", "PUT", "DELETE", "OPTIONS");
                });
});


var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseCors();

app.UseAuthorization();

app.MapControllers();

app.Run();
