using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AsteroidBelt : MonoBehaviour
{
    public int Count;
    public float Speed;
    public float RadMin;
    public float RadMax;
    public float MinSize;
    public float MaxSize;

    private List<Tuple<GameObject, Vector2>> _asteroids;
    void Start()
    {
        _asteroids = new List<Tuple<GameObject, Vector2>>(Count);
        for (int i = 0; i < Count; ++i)
        {
            var go = GameObject.CreatePrimitive(PrimitiveType.Cube);
            go.transform.localScale = Vector3.one * UnityEngine.Random.Range(MinSize, MaxSize);
            go.transform.rotation = Quaternion.EulerRotation(UnityEngine.Random.Range(0.0f, 10.0f), UnityEngine.Random.Range(0.0f, 10.0f), UnityEngine.Random.Range(0.0f, 10.0f));
            go.transform.parent = this.gameObject.transform;
            var off = new Vector2(UnityEngine.Random.Range(0.0f, 10.0f), UnityEngine.Random.Range(RadMin, RadMax));
            _asteroids.Add(new Tuple<GameObject, Vector2>(go, off));
        }
    }

    void Update()
    {
        foreach (var aster in _asteroids)
        {
            aster.Item1.transform.localPosition =
                new Vector3(
                    Mathf.Sin(Time.realtimeSinceStartup * Speed + aster.Item2.x),
                    0.0f,
                    Mathf.Cos(Time.realtimeSinceStartup * Speed + aster.Item2.x))
                * aster.Item2.y;
        }
    }
}
