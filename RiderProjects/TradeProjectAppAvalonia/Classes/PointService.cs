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
    public class PointService
    {
        private readonly HttpClient _httpClient = new HttpClient();
        private readonly Messages _messages = new Messages();
        private const string pointUrl = "https://localhost:44330/api/point";

        // Получение списка пунктов выдачи с фильтрацией через Sieve
        public Task<List<Point>?> GetPointsAsync(SieveModel sieveModel) =>
            SendRequestAsync<List<Point>>(HttpMethod.Get, $"{pointUrl}?Filters={sieveModel.Filters}&Sorts={sieveModel.Sorts}&Page={sieveModel.Page}&PageSize={sieveModel.PageSize}");

        // Обновление пункта выдачи
        public Task<Point?> UpdatePointAsync(int pointId, Point point) =>
            SendRequestAsync<Point>(HttpMethod.Put, $"{pointUrl}/{pointId}", point);

        // Удаление пункта выдачи
        public async Task<bool> RemovePointAsync(int pointId)
        {
            var success = await SendRequestAsync<object>(HttpMethod.Delete, $"{pointUrl}/{pointId}") != null;
            if (success)
            {
                Console.WriteLine($"Пункт выдачи с id {pointId} успешно удалён.");
            }
            return success;
        }

        // Добавление пункт выдачи
        public Task<Point?> AddPointAsync(Point point) =>
             SendRequestAsync<ApiResponse>(HttpMethod.Post, $"{pointUrl}", point)
               .ContinueWith(t => t.Result?.Point);

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
                    request.Content = new StringContent(jsonData, System.Text.Encoding.UTF8, "application/json");
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
