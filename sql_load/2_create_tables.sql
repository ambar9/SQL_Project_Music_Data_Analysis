CREATE TABLE public.album
(
    album_id character varying(30) NOT NULL,
    title character varying(150),
    artist_id character varying(30),
    PRIMARY KEY (album_id)
)
WITH (
    OIDS = FALSE
);

CREATE TABLE public.artist
(
    artist_id character varying(30) NOT NULL,
    name character varying(150),
    PRIMARY KEY (artist_id)
)
WITH (
    OIDS = FALSE
);

CREATE TABLE public.customer
(
    customer_id character varying(30) NOT NULL,
    first_name character(30),
    last_name character(30),
    company character varying(150),
    address character varying(250),
    city character varying(30),
    state character varying(30),
    country character varying(30),
    postal_code character varying(30),
    phone character varying(30),
    fax character varying(30),
    email character varying(30),
    support_rep_id character varying(30),
    PRIMARY KEY (customer_id)
)
WITH (
    OIDS = FALSE
);

CREATE TABLE public.employee
(
    employee_id character varying(30) NOT NULL,
    last_name character(50),
    first_name character(50),
    title character varying(250),
    reports_to character varying(30),
    levels character varying(10),
    birth_date timestamp,
    hire_date timestamp,
    address character varying(120),
    city character varying(50),
    state character varying(50),
    country character varying(30),
    postal_code character varying(30),
    phone character varying(30),
    fax character varying(30),
    email character varying(30),
    PRIMARY KEY (employee_id)
)
WITH (
    OIDS = FALSE
);

CREATE TABLE public.genre
(
    genre_id character varying(30) NOT NULL,
    name character varying(50),
    PRIMARY KEY (genre_id)
)
WITH (
    OIDS = FALSE
);


CREATE TABLE public.invoice
(
    invoice_id character varying(30) NOT NULL,
    customer_id character varying(30),
    invoice_date timestamp,
    billing_address character varying(120),
    billing_city character varying(30),
    billing_state character varying(30),
    billing_country character varying(30),
    billing_postal_code character varying(30),
    total double precision,
    PRIMARY KEY (invoice_id)
)
WITH (
    OIDS = FALSE
);



CREATE TABLE public.invoice_line
(
    invoice_line_id character varying(30) NOT NULL,
    invoice_id character varying(30),
    track_id character varying(30),
    unit_price numeric,
    quantity integer,
    PRIMARY KEY (invoice_line_id)
)
WITH (
    OIDS = FALSE
)
select * from invoice_line

CREATE TABLE public.media_type
(
    media_type_id character varying(30) NOT NULL,
    name character varying(30),
    PRIMARY KEY (media_type_id)
)
WITH (
    OIDS = FALSE
);
Select * from public.media_type

CREATE TABLE public.playlist
(
    playlist_id character varying(30) NOT NULL,
    name character varying(50),
    PRIMARY KEY (playlist_id)
)
WITH (
    OIDS = FALSE
);
Select * from public.playlist


CREATE TABLE public.playlist_track
(
    playlist_id character varying(30),
    track_id character varying(50)
)
WITH (
    OIDS = FALSE
);

Select * from public.playlist_track


CREATE TABLE public.track
(
    track_id character varying(30) NOT NULL,
    name character varying(250),
    album_id character varying(30),
    media_type_id character varying(30),
    genre_id character varying(30),
    composer character varying(250),
    milliseconds bigint,
    bytes integer,
    unit_price numeric,
    PRIMARY KEY (track_id)
)
WITH (
    OIDS = FALSE
);
Select * from public.track


ALTER TABLE public.album
    ADD FOREIGN KEY (artist_id)
    REFERENCES public.artist (artist_id)
    ON DELETE CASCADE
    NOT VALID;


ALTER TABLE public.customer
    ADD FOREIGN KEY (support_rep_id)
    REFERENCES public.employee (employee_id)
    ON DELETE CASCADE
    NOT VALID;


ALTER TABLE public.employee
    ADD FOREIGN KEY (reports_to)
    REFERENCES public.employee (employee_id)
    ON DELETE CASCADE
    NOT VALID;


ALTER TABLE public.invoice
    ADD FOREIGN KEY (customer_id)
    REFERENCES public.customer (customer_id)
    ON DELETE CASCADE
    NOT VALID;


ALTER TABLE public.invoice_line
    ADD FOREIGN KEY (invoice_id)
    REFERENCES public.invoice (invoice_id)
    ON DELETE CASCADE
    NOT VALID;


ALTER TABLE public.invoice_line
    ADD FOREIGN KEY (track_id)
    REFERENCES public.track (track_id)
    ON DELETE CASCADE
    NOT VALID;


ALTER TABLE public.playlist_track
    ADD FOREIGN KEY (playlist_id)
    REFERENCES public.playlist (playlist_id)
    ON DELETE CASCADE
    NOT VALID;


ALTER TABLE public.playlist_track
    ADD FOREIGN KEY (track_id)
    REFERENCES public.track (track_id)
    ON DELETE CASCADE
    NOT VALID;


ALTER TABLE public.track
    ADD FOREIGN KEY (album_id)
    REFERENCES public.album (album_id)
    ON DELETE CASCADE
    NOT VALID;


ALTER TABLE public.track
    ADD FOREIGN KEY (genre_id)
    REFERENCES public.genre (genre_id)
    ON DELETE CASCADE
    NOT VALID;


ALTER TABLE public.track
    ADD FOREIGN KEY (media_type_id)
    REFERENCES public.media_type (media_type_id)
    ON DELETE CASCADE
    NOT VALID;


ALTER TABLE public.album OWNER TO postgres;
ALTER TABLE public.artist OWNER TO postgres;
ALTER TABLE public.customer OWNER TO postgres;
ALTER TABLE public.employee OWNER TO postgres;
ALTER TABLE public.genre OWNER TO postgres;
ALTER TABLE public.invoice OWNER TO postgres;
ALTER TABLE public.invoice_line OWNER TO postgres;
ALTER TABLE public.media_type OWNER TO postgres;
ALTER TABLE public.playlist OWNER TO postgres;
ALTER TABLE public.playlist_track OWNER TO postgres;
ALTER TABLE public.track OWNER TO postgres;



CREATE INDEX idx_album_artist_id ON public.album (artist_id);
CREATE INDEX idx_customer_support_rep_id ON public.customer (support_rep_id);
CREATE INDEX idx_employee_reports_to ON public.employee (reports_to);
CREATE INDEX idx_invoice_customer_id ON public.invoice (customer_id);
CREATE INDEX idx_invoice_line_invoice_id ON public.invoice_line (invoice_id);
CREATE INDEX idx_invoice_line_track_id ON public.invoice_line (track_id);
CREATE INDEX idx_playlist_track_playlist_id ON public.playlist_track (playlist_id);
CREATE INDEX idx_playlist_track_track_id ON public.playlist_track (track_id);
CREATE INDEX idx_track_album_id ON public.track (album_id);
CREATE INDEX idx_track_genre_id ON public.track (genre_id);
CREATE INDEX idx_track_media_type_id ON public.track (media_type_id);
