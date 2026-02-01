using System;
using System.Collections.Generic;

namespace testfromdock.Models;

public partial class J
{
    public string Id { get; set; } = null!;

    public string Name { get; set; } = null!;

    public string City { get; set; } = null!;

    public virtual ICollection<Spj> Spj { get; set; } = new List<Spj>();
}
