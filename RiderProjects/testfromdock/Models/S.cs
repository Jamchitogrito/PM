using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace testfromdock.Models;

public partial class S
{
    [Display(Name ="Индекс")]
    public string Id { get; set; } = null!;
    [Display(Name ="Фамилия")]
    public string Surname { get; set; } = null!;
    [Display(Name ="Рейтинг")]
    public int Raiting { get; set; }
    [Display(Name ="Город")]
    public string City { get; set; } = null!;
    [Display(Name ="Лист")]

    public virtual ICollection<Spj> Spj { get; set; } = new List<Spj>();
}
