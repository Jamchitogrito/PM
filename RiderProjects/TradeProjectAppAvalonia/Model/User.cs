using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace TradeProjectAppAvalonia.Model;

public partial class User
{
    public int UserId { get; set; }

    public string Surname { get; set; } = null!;

    public string Name { get; set; } = null!;

    public string? Patronymic { get; set; }

    public string? Login { get; set; }

    public string? Password { get; set; }

    public int Role { get; set; }

    public virtual ICollection<Order> Orders { get; set; } = new List<Order>();

    public virtual Role RoleNavigation { get; set; } = null!;
}

public class LoginModel
{
    [Required(ErrorMessage = "Логин обязателен для заполнения")]
    [StringLength(25, MinimumLength = 3, ErrorMessage = "Логин должен быть от 3 до 25 символов")]
    public string Login { get; set; } = null!;

    [Required(ErrorMessage = "Пароль обязателен для заполнения")]
    [StringLength(50, ErrorMessage = "Пароль не должен превышать 50 символов")]
    public string Password { get; set; } = null!;
}