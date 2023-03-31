<<<<<<< Updated upstream
﻿using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using RESTful_API.Models;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace RESTful_API.Controllers
{
=======
﻿using Microsoft.AspNetCore.Cors;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Razor.Infrastructure;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Newtonsoft.Json;
using RESTful_API.Interface;
using RESTful_API.Models;
using RESTful_API.Repository;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Security.Policy;
using System.Text;
using System.Text.Json.Serialization;

namespace RESTful_API.Controllers
{
    [EnableCors("MyPolicy")]
>>>>>>> Stashed changes
    [Route("api/token")]
    [ApiController]
    public class TokenController : ControllerBase
    {
        public IConfiguration _configuration;
        private readonly DatabaseContext _context;

        public TokenController(IConfiguration config, DatabaseContext context)
        {
            _configuration = config;
            _context = context;
        }

        [HttpPost]
        public async Task<IActionResult> Post(User _userData)
        {
            if (_userData != null && _userData.Email != null && _userData.Password != null)
            {
<<<<<<< Updated upstream
                var user = await UserLogin(_userData.Email, _userData.Password);
=======
                var user = await UserLogin(_userData.Email, _userData.Password, _userData);
>>>>>>> Stashed changes

                if (user != null)
                {
                    //create claims details based on the user information
                    var claims = new[] {
                        new Claim(JwtRegisteredClaimNames.Sub, _configuration["Jwt:Subject"]),
                        new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
                        new Claim(JwtRegisteredClaimNames.Iat, DateTime.UtcNow.ToString()),
                        new Claim("UserID", user.UserID.ToString()),
<<<<<<< Updated upstream
                        new Claim("First_Name", user.First_Name),
                        new Claim("Last_Name", user.Last_Name),
=======
>>>>>>> Stashed changes
                        new Claim("Email", user.Email)
                    };

                    var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration["Jwt:Key"]));
                    var signIn = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);
                    var token = new JwtSecurityToken(
                        _configuration["Jwt:Issuer"],
                        _configuration["Jwt:Audience"],
                        claims,
<<<<<<< Updated upstream
                        expires: DateTime.UtcNow.AddMinutes(10),
                        signingCredentials: signIn);

                    return Ok(new JwtSecurityTokenHandler().WriteToken(token));
=======
                        expires: DateTime.UtcNow.AddMinutes(60), 
                        signingCredentials: signIn);


                    var response = new[]
                    {
                        new {Token = new JwtSecurityTokenHandler().WriteToken(token), User = user, ID = FetchID(user.UserID, user.Role.ToString())}
                    };

                    return Ok(JsonConvert.SerializeObject(response));
>>>>>>> Stashed changes
                }
                else
                {
                    return BadRequest("Invalid credentials");
                }
            }
            else
            {
                return BadRequest();
            }
        }

<<<<<<< Updated upstream
        private async Task<User> UserLogin(string email, string password)
        {
            return await _context.Users.FirstOrDefaultAsync(u => u.Email == email && u.Password == password);
        }
=======
        private async Task<User> UserLogin(string email, string password, User userData)
        {
            return await _context.Users.FirstOrDefaultAsync(u => u.Email == email && u.Password == password);
        }

        private int FetchID(int id, string role)
        {
            switch (role)
            {
                case "Admin":
                    return _context.Admins.Where(a => a.UserID == id).Select(y => y.AdminID).Single();
                case "Student":
                    return _context.Students.Where(a => a.UserID == id).Select(y => y.StudentID).Single();
                case "Lecturer":
                    return _context.Lecturers.Where(a => a.UserID == id).Select(y => y.LecturerID).Single();
                case "Secretary":
                    return _context.Secretarys.Where(a => a.UserID == id).Select(y => y.SecretaryID).Single();
                default: return 0;
            }
            
        }
>>>>>>> Stashed changes
    }
}
