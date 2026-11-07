<?php
declare(strict_types=1);

header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Headers: Content-Type, X-Requested-With');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(204);
    exit;
}

function respond(int $status, array $payload): void {
    http_response_code($status);
    echo json_encode($payload, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    exit;
}

function readJson(): array {
    $raw = file_get_contents('php://input');
    $data = json_decode($raw ?: '', true);
    if (!is_array($data)) {
        respond(400, ['success' => false, 'message' => 'Body JSON tidak valid.']);
    }
    return $data;
}

function requiredString(array $data, string $key): string {
    $value = trim((string)($data[$key] ?? ''));
    if ($value === '' && $key !== 'imagePath') {
        respond(422, ['success' => false, 'message' => "Kolom {$key} wajib diisi."]);
    }
    return $value;
}

try {
    // Default XAMPP: user root, password kosong.
    // Jika konfigurasi MySQL kamu berbeda, ubah tiga nilai berikut.
    $db = new mysqli('localhost', 'root', '', 'my_portfolio_db');
    $db->set_charset('utf8mb4');

    $method = $_SERVER['REQUEST_METHOD'];

    if ($method === 'GET') {
        $result = $db->query(
            'SELECT id, category, title, year, technology, description, imagePath FROM portfolios ORDER BY id ASC'
        );
        $rows = [];
        while ($row = $result->fetch_assoc()) {
            $row['id'] = (int)$row['id'];
            $rows[] = $row;
        }
        respond(200, ['success' => true, 'data' => $rows]);
    }

    if ($method === 'POST') {
        $data = readJson();
        $category = requiredString($data, 'category');
        $title = requiredString($data, 'title');
        $year = requiredString($data, 'year');
        $technology = requiredString($data, 'technology');
        $description = requiredString($data, 'description');
        $imagePath = requiredString($data, 'imagePath');

        $stmt = $db->prepare(
            'INSERT INTO portfolios (category, title, year, technology, description, imagePath) VALUES (?, ?, ?, ?, ?, ?)'
        );
        $stmt->bind_param('ssssss', $category, $title, $year, $technology, $description, $imagePath);
        $stmt->execute();
        respond(201, ['success' => true, 'message' => 'Portofolio berhasil ditambahkan.', 'id' => $db->insert_id]);
    }

    if ($method === 'PUT') {
        $data = readJson();
        $id = (int)($data['id'] ?? 0);
        if ($id <= 0) {
            respond(422, ['success' => false, 'message' => 'ID portofolio tidak valid.']);
        }
        $category = requiredString($data, 'category');
        $title = requiredString($data, 'title');
        $year = requiredString($data, 'year');
        $technology = requiredString($data, 'technology');
        $description = requiredString($data, 'description');
        $imagePath = requiredString($data, 'imagePath');

        $stmt = $db->prepare(
            'UPDATE portfolios SET category = ?, title = ?, year = ?, technology = ?, description = ?, imagePath = ? WHERE id = ?'
        );
        $stmt->bind_param('ssssssi', $category, $title, $year, $technology, $description, $imagePath, $id);
        $stmt->execute();
        if ($stmt->affected_rows === 0) {
            $check = $db->prepare('SELECT id FROM portfolios WHERE id = ?');
            $check->bind_param('i', $id);
            $check->execute();
            $exists = $check->get_result()->num_rows > 0;
            if (!$exists) respond(404, ['success' => false, 'message' => 'Portofolio tidak ditemukan.']);
        }
        respond(200, ['success' => true, 'message' => 'Portofolio berhasil diperbarui.']);
    }

    if ($method === 'DELETE') {
        $id = (int)($_GET['id'] ?? 0);
        if ($id <= 0) {
            respond(422, ['success' => false, 'message' => 'ID portofolio tidak valid.']);
        }
        $stmt = $db->prepare('DELETE FROM portfolios WHERE id = ?');
        $stmt->bind_param('i', $id);
        $stmt->execute();
        if ($stmt->affected_rows === 0) {
            respond(404, ['success' => false, 'message' => 'Portofolio tidak ditemukan.']);
        }
        respond(200, ['success' => true, 'message' => 'Portofolio berhasil dihapus.']);
    }

    respond(405, ['success' => false, 'message' => 'Metode request tidak didukung.']);
} catch (Throwable $error) {
    // Detail teknis dicatat server, respons tetap berbentuk JSON.
    error_log($error->getMessage());
    respond(500, [
        'success' => false,
        'message' => 'Terjadi masalah pada server/database. Pastikan MySQL aktif dan database my_portfolio_db sudah diimpor.'
    ]);
}