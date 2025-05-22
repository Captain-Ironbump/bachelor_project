INSERT INTO tag (tag, tag_color)
  VALUES ('java', 'RED');

INSERT INTO tag (tag, tag_color)
  VALUES ('python', 'BLUE');
  
INSERT INTO learner (first_name, last_name)
  VALUES (
      'Max',
      'Mustermann'
    );

INSERT INTO learner (first_name, last_name)
  VALUES (
      'Lukas',
      'Linde'
    );

INSERT INTO event (name)
  VALUES (
    'Software Engineering'
  );

INSERT INTO event (name)
  VALUES (
    'Database Systems'
  );

INSERT INTO observation (event_id, learner_id, raw_observation, created_date)
  VALUES(
    1,
    1,
    'sdasdfsdfad',
    '2025-05-14 00:00:00.000000'
  );

INSERT INTO observation (event_id, learner_id, raw_observation, created_date)  
  VALUES(
    1,
    2,
    'sdasdafdfdfeqwedq',
    '2025-05-14 00:00:00.000000'
  );

INSERT INTO observation (event_id, learner_id, raw_observation, created_date)  
  VALUES(
    2,
    1,
    'adiufhoqijdofiheo',
    '2025-05-14 00:00:00.000000'
  );

INSERT INTO observation (event_id, learner_id, raw_observation, created_date)
  VALUES(
    2,
    1,
    'dofidoipiowepofkperij',
    '2025-05-14 00:00:00.000000'
  );

INSERT INTO observation (event_id, learner_id, raw_observation, created_date)
  VALUES(
    1,
    1,
    'The student demonstrated a solid understanding of object-oriented principles by creating a Vehicle superclass with common attributes and methods, and extending it through subclasses like Car and Bike. Each subclass overrode the startEngine() method to provide behavior specific to the vehicle type, effectively applying polymorphism. The student also instantiated objects through the Vehicle reference, showcasing runtime polymorphism in action.',
    '2025-05-14 00:00:00.000000'
  );

INSERT INTO learner_event (event_id, learner_id)
  VALUES(
    1,
    1
  );

INSERT INTO learner_event (event_id, learner_id)
  VALUES(
    1,
    2
  );

INSERT INTO learner_event (event_id, learner_id)
  VALUES(
    2,
    2
  );

INSERT INTO learner_event (event_id, learner_id)
  VALUES(
    2,
    1
  );

INSERT INTO observation_tags (observation_id, tag)
  VALUES(
    1,
    'java'
  );

INSERT INTO observation_tags (observation_id, tag)
  VALUES(
    2,
    'java'
  );

INSERT INTO observation_tags (observation_id, tag)
  VALUES(
    1,
    'python'
  );

INSERT INTO observation_tags (observation_id, tag)
  VALUES(
    4,
    'python'
  );

INSERT INTO report (created_date, learner_id, event_id, report_data)
  VALUES(
    '2025-05-14 00:00:00.000000',
    1,
    1,
    'Hier kommt mal was mega tolles rein, aber im Moment muss das hier langen.'
  );