using System;
using System.IO;
using System.Reflection;

namespace testfromdock.Helpers;

public static class SqlFileReader
{
    public static string GetSqlQuery(string fileName)
    {
        try
        {
            var assembly = Assembly.GetExecutingAssembly();
            var resourceName = $"testfromdock.SQL.{fileName}";
            
            using (var stream = assembly.GetManifestResourceStream(resourceName))
            {
                if (stream == null)
                {
                    var filePath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "SQL", fileName);
                    if (File.Exists(filePath))
                    {
                        return File.ReadAllText(filePath);
                    }
                    
                    throw new FileNotFoundException($"не найден: {resourceName}");
                }
                
                using (var reader = new StreamReader(stream))
                {
                    return reader.ReadToEnd();
                }
            }
        }
        catch (Exception ex)
        {
            throw new Exception($"Ошибка '{fileName}': {ex.Message}", ex);
        }
    }
    
    public static string GetSqlQuery(string fileName, params (string key, string value)[] parameters)
    {
        var sql = GetSqlQuery(fileName);
        
        foreach (var param in parameters)
        {
            sql = sql.Replace($"{{{param.key}}}", param.value);
        }
        
        return sql;
    }
}