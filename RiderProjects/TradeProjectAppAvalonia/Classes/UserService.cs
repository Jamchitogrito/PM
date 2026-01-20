using Newtonsoft.Json;
using Sieve.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using TradeProjectAppAvalonia.Model;

namespace TradeProjectAppAvalonia.Classes
{
    public class UserService
    {
        private readonly HttpClient _httpClient = new HttpClient();
        private readonly Messages _messages = new Messages();
        private const string userUrl = "https://localhost:44330/api/user";

        // Получение списка пользователей с фильтрацией через Sieve
        public Task<List<User>?> GetUsersAsync(SieveModel sieveModel) =>
            SendRequestAsync<List<User>>(HttpMethod.Get, $"{userUrl}?Filters={sieveModel.Filters}&Sorts={sieveModel.Sorts}&Page={sieveModel.Page}&PageSize={sieveModel.PageSize}");

        // Получение пользователя по ID
        public Task<User?> GetUserByIdAsync(int id) =>
            SendRequestAsync<User>(HttpMethod.Get, $"{userUrl}/{id}");

        // Получение пользователя по логину
        public Task<User?> GetUserByLoginAsync(string login) =>
            SendRequestAsync<User>(HttpMethod.Get, $"{userUrl}/{login}");

        // Добавление пользователя
        public Task<User?> CreateUserAsync(User user)
        {
            return SendRequestAsync<ApiResponse>(HttpMethod.Post, userUrl, user)
                .ContinueWith(t => t.Result?.User);

        }
        // Регистрация пользователя
        public Task<User?> RegisterUserAsync(User user) =>
            SendRequestAsync<ApiResponse>(HttpMethod.Post, $"{userUrl}/register", user)
            .ContinueWith(t => t.Result?.User);

        // Авторизация пользователя
        public Task<User?> LoginUserAsync(LoginModel loginModel) =>
            SendRequestAsync<User>(HttpMethod.Post, $"{userUrl}/login", loginModel);


        // Обновление данных пользователя
        public Task<User?> UpdateUserAsync(int userId, User user) =>
            SendRequestAsync<User>(HttpMethod.Put, $"{userUrl}/{userId}", user);


        // Удаление пользователя
        public async Task<bool> RemoveUserAsync(int userId)
        {
            var success = await SendRequestAsync<object>(HttpMethod.Delete, $"{userUrl}/{userId}") != null;
            if (success)
            {
                Console.WriteLine($"Пользователь с id {userId} успешно удалён.");
            }
            return success;
        }

        // Универсальный метод для отправки запросов и обработки ответов
        private async Task<T?> SendRequestAsync<T>(HttpMethod method, string url, object? data = null)
        {
            try
            {
                var request = new HttpRequestMessage(method, url);
                if (data != null)
                {
                    var jsonData = JsonConvert.SerializeObject(data, new JsonSerializerSettings
                    {
                        ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                    });
                    request.Content = new StringContent(jsonData, Encoding.UTF8, "application/json");
                }

                var response = await _httpClient.SendAsync(request);
                var json = await response.Content.ReadAsStringAsync();

                if (!response.IsSuccessStatusCode)
                {
                    _messages.ShowError(json);
                    return default;
                }

                return JsonConvert.DeserializeObject<T>(json);
            }
            catch (HttpRequestException ex)
            {
                _messages.ShowError($"Ошибка при выполнении запроса: {ex.Message}");
                return default;
            }
            catch (Exception ex)
            {
                _messages.ShowError($"Неизвестная ошибка: {ex.Message}");
                return default;
            }
        }
    }
}
