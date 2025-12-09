-- Create the bookings table for Booking Restaurant system
CREATE TABLE IF NOT EXISTS bookings (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(50) NOT NULL,
    date DATE NOT NULL,
    time TIME NOT NULL,
    party_size INTEGER NOT NULL DEFAULT 1,
    allergies TEXT,
    special_requests TEXT,
    event_id VARCHAR(255),
    event_link TEXT,
    calendar_event JSONB,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create index on email for faster queries
CREATE INDEX IF NOT EXISTS idx_bookings_email ON bookings(email);

-- Create index on date for availability queries
CREATE INDEX IF NOT EXISTS idx_bookings_date ON bookings(date);

-- Create index on date and time for conflict checking
CREATE INDEX IF NOT EXISTS idx_bookings_date_time ON bookings(date, time);

-- Insert dummy data
INSERT INTO bookings (name, email, phone, date, time, party_size, allergies, special_requests, event_id, event_link, calendar_event, timestamp) VALUES
('John Doe', 'john.doe@example.com', '+62123456789', '2025-12-01', '14:00:00', 4, 'Peanuts', 'Window seat please', 'event123456', 'https://calendar.google.com/event?eid=event123456', '{"summary": "Booking Restaurant - John Doe", "start": {"dateTime": "2025-12-01T14:00:00+08:00"}, "end": {"dateTime": "2025-12-01T14:30:00+08:00"}}', '2025-11-30T07:00:00Z'),
('Jane Smith', 'jane.smith@example.com', '+62123456790', '2025-12-02', '12:00:00', 2, '', 'Birthday celebration', 'event234567', 'https://calendar.google.com/event?eid=event234567', '{"summary": "Booking Restaurant - Jane Smith", "start": {"dateTime": "2025-12-02T12:00:00+08:00"}, "end": {"dateTime": "2025-12-02T12:30:00+08:00"}}', '2025-11-30T08:15:00Z'),
('Ahmad Rahman', 'ahmad.rahman@example.com', '+62123456791', '2025-12-03', '18:30:00', 6, 'Shellfish, Dairy', 'Private room if available', 'event345678', 'https://calendar.google.com/event?eid=event345678', '{"summary": "Booking Restaurant - Ahmad Rahman", "start": {"dateTime": "2025-12-03T18:30:00+08:00"}, "end": {"dateTime": "2025-12-03T19:00:00+08:00"}}', '2025-11-30T09:30:00Z'),
('Maria Garcia', 'maria.garcia@example.com', '+62123456792', '2025-12-04', '19:00:00', 3, 'Gluten', '', 'event456789', 'https://calendar.google.com/event?eid=event456789', '{"summary": "Booking Restaurant - Maria Garcia", "start": {"dateTime": "2025-12-04T19:00:00+08:00"}, "end": {"dateTime": "2025-12-04T19:30:00+08:00"}}', '2025-11-30T10:45:00Z'),
('David Chen', 'david.chen@example.com', '+62123456793', '2025-12-05', '13:30:00', 1, '', 'Quick lunch meeting', 'event567890', 'https://calendar.google.com/event?eid=event567890', '{"summary": "Booking Restaurant - David Chen", "start": {"dateTime": "2025-12-05T13:30:00+08:00"}, "end": {"dateTime": "2025-12-05T14:00:00+08:00"}}', '2025-11-30T11:20:00Z');

-- Update trigger for updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_bookings_updated_at BEFORE UPDATE ON bookings FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();