using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ParticleTest : MonoBehaviour
{
    ParticleSystem particles;
    ParticleSystem.Particle[] particlesArr;
    Material material;
    // Start is called before the first frame update
    void Start()
    {
        particles = this.gameObject.GetComponent<ParticleSystem>();
        particlesArr = new ParticleSystem.Particle[particles.particleCount];
    }

    void Update()
    {
        particles.GetParticles(particlesArr);

        //particlesArr[0].position
        //material.SetVectorArray("_MyPositions", )
        


    }
}
